---
layout: post
title: OctoDNS 0.19.4 and Cloudflare Authentication Error
date: 2022-02-02 14:02:32 +0900
last_modified: 2022-02-02 14:02:32 +0900
category: blog
---

I use Cloudflare and [OctoDNS](https://github.com/octodns/octodns) to manage my DNS zones. Today I updated OctoDNS from 0.19.2 to 0.19.4 and run into the following authentication error:

```
octodns_cloudflare.CloudflareAuthenticationError: Unauthorized to access requested resource
Traceback (most recent call last):
  File "/PATH/TO/REPO/github.com/lowply/dns/env/bin/octodns-dump", line 8, in <module>
    sys.exit(main())
  File "/PATH/TO/REPO/github.com/lowply/dns/env/lib/python3.9/site-packages/octodns/cmds/dump.py", line 34, in main
    manager.dump(args.zone, args.output_dir, args.lenient, args.split,
  File "/PATH/TO/REPO/github.com/lowply/dns/env/lib/python3.9/site-packages/octodns/manager.py", line 519, in dump
    source.populate(zone, lenient=lenient)
  File "/PATH/TO/REPO/github.com/lowply/dns/env/lib/python3.9/site-packages/octodns_cloudflare/__init__.py", line 328, in populate
    records = self.zone_records(zone)
  File "/PATH/TO/REPO/github.com/lowply/dns/env/lib/python3.9/site-packages/octodns_cloudflare/__init__.py", line 291, in zone_records
    resp = self._try_request('GET', path, params={'status': 'active'})
  File "/PATH/TO/REPO/github.com/lowply/dns/env/lib/python3.9/site-packages/octodns_cloudflare/__init__.py", line 84, in _try_request
    return self._request(*args, **kwargs)
  File "/PATH/TO/REPO/github.com/lowply/dns/env/lib/python3.9/site-packages/octodns_cloudflare/__init__.py", line 105, in _request
    raise CloudflareAuthenticationError(resp.json())
octodns_cloudflare.CloudflareAuthenticationError: Unauthorized to access requested resource
```

I've checked the Cloudflare token but it wasn't expired. I rolled it just in case, but no luck. I learned that OctoDNS now separates providers into a different repositories, such as [octodns/octodns-cloudflare](https://github.com/octodns/octodns-cloudflare) so I installed it via `pip` and updated the _config/production.yaml_ file to use it, but the error persists.

Quick GitHub search retuened an interesting issue: [CloudflareAuthenticationError with valid token in 0.9.14 · Issue #791 · octodns/octodns](https://github.com/octodns/octodns/issues/791). According to the report, it seems that the token now needs the `Zone.Page Rules:Read` permission in addition to what it has been required: `Zone.DNS:Edit`.

{% include img.html name="cf.png" %}

Adding the permission fixed the authentication error.
