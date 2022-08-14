---
title: Using Hugo with the new GitHub Pages
date: 2022-08-12T00:56:52+09:00
draft: false
---

The news about [GitHub Pages being backed by GitHub Actions](https://github.blog/changelog/2021-12-16-github-pages-using-github-actions-for-builds-and-deployments-for-public-repositories/) exited me a lot. Since [it's GAed with the custom workflow](https://github.blog/2022-08-10-github-pages-now-uses-actions-by-default/) last week, I'm once again migrating this blog [from Jyekyll](/blog/2020/10/jekyll/) to Hugo and deploying it using GitHub Actions.

Migration was pretty straightforward. I re-learned Hugo by reading the docs (and was impressed by its design again!), did some search and replace `:bufdo :%s///g` on Vim to convert Jekyll tags to Hugo tags, rewrote one shortcode, made some minor updates to permalinks and asset paths etc.

One thing I had to spend some time to come up with the solution was redirecting the old RSS feed. With Jekyll the feed URL was `feed.xml` whereas with Hugo it's `index.xml`. Hugo's [aliases](https://gohugo.io/content-management/urls/#aliases) doesn't support redirecting these files, so I end up creating the `feed.xml` file in the `static` directory:

```xml
<redirect>
    <newLocation>
        https://lowply.github.io/index.xml
    </newLocation>
</redirect>
```

ref. [How to Redirect an RSS Feed](https://www.rssboard.org/redirect-rss-feed)