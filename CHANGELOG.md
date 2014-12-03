Omnijack Gem CHANGELOG
======================

v?.?.? (????-??-??)
-------------------
- Replace every instance of `getchef.com` with `chef.io`

v1.0.0 (2014-10-24)
-------------------
- Remove dependency on `ohai`; require platform arguments for metadata
- Swap out `json` dependency for `multi_json`

v0.2.0 (2014-09-19)
-------------------
- Calculate and expose version and build numbers as part of metadata
- Populate project metadata immediately instead of the first time
`metadata.to_h` is called
- Remove version string validation to allow for nightly build versions

v0.1.2 (2014-09-17)
-------------------
- Fix encoding issue with incorrect filename for nightly build packages

v0.1.1 (2014-09-12)
-------------------
- Don't load vendored Chef classes if Chef itself is already loaded

v0.1.0 (2014-09-12)
-------------------
- Initial release!

v0.0.1 (2014-09-02)
-------------------
- Development started
