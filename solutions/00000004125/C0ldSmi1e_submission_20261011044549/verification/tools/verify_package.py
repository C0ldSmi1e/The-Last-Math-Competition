#!/usr/bin/env python3
"""Verify all delivered bytes and archive members without extracting archives."""
from pathlib import Path, PurePosixPath
import hashlib,json,sys,tarfile

root=(Path(sys.argv[1]) if len(sys.argv)>1 else Path(__file__).resolve().parent.parent).resolve()
def sha_file(path):
    h=hashlib.sha256()
    with path.open('rb') as stream:
        for chunk in iter(lambda:stream.read(1048576),b''):h.update(chunk)
    return h.hexdigest()
def allowed_name(name):
    path=PurePosixPath(name)
    assert not path.is_absolute() and '..' not in path.parts and name==path.as_posix(),name
    assert not set(path.parts)&{'.git','.lake','__pycache__'},name
    assert path.suffix not in {'.pyc','.pyo','.olean','.ilean'},name

manifest=json.loads((root/'bundle-manifest.json').read_text())
actual={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file()}
assert actual==set(manifest['files'])|{'bundle-manifest.json'}
for name,row in manifest['files'].items():
    allowed_name(name);path=root/name
    assert not path.is_symlink() and path.stat().st_size==row['bytes']
    assert sha_file(path)==row['sha256'],name
active_lean={n for n in actual if n.endswith('.lean')}
assert not active_lean
archive_counts={}
for archive,listing in manifest['archives'].items():
    records=json.loads((root/listing).read_text())['members']
    seen=set()
    with tarfile.open(root/archive,'r:gz') as tar:
        for member in tar:
            allowed_name(member.name)
            assert member.isfile() and member.name not in seen
            seen.add(member.name)
            row=records[member.name]
            assert member.size==row['bytes']
            stream=tar.extractfile(member);assert stream is not None
            h=hashlib.sha256()
            for chunk in iter(lambda:stream.read(1048576),b''):h.update(chunk)
            assert h.hexdigest()==row['sha256'],member.name
    assert seen==set(records),archive
    archive_counts[archive]=len(seen)
print(json.dumps({'status':'PASS','bundle_files':len(actual),'archive_members':archive_counts,
    'bundle_manifest_sha256':sha_file(root/'bundle-manifest.json'),
    'scope':'Content integrity and safe archive structure; not a fresh Lean proof replay.'},indent=2))
