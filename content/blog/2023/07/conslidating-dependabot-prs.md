---
title: Consolidating Dependabot PRs by cherry-picking commits
date: 2023-07-10T10:08:33+09:00
description: OPTIONAL
draft: false
---

Overwhelmed by Dependabot PRs every week? Instead of approving, deploying, and merging them one by one, you can consolidate them into one PR. Here's how to do it.

_Note: [Grouped version updates for Dependabot public beta](https://github.blog/changelog/2023-06-30-grouped-version-updates-for-dependabot-public-beta/) is coming soon, but I think this is still useful on certain occasions._

First, checkout to a new branch:

```shell
git co -b "lowply/dependabot-rollup-$(date +%Y-%m-%d)"
```

Pull commits. Thanks to the [GitHub GraphQL API](https://docs.github.com/en/graphql), it's just one API request!

```shell
OWNER="owner"
REPO="repo"
LABEL="dependencies"
STATUS="OPEN"
COMMITS=$(gh api graphql -F owner="${OWNER}" -F name="${REPO}" -F labels="${LABEL}" -F states="${STATUS}" -f query='
    query($name: String!, $owner: String!, $labels: [String!], $states: [PullRequestState!]) {
      repository(owner: $owner, name: $name) {
        pullRequests(first: 100, labels: $labels, states: $states) {
          nodes {
            title,
            commits (first: 100) {
              nodes {
                commit {
                  oid
                }
              }
            }
          }
        }
      }
    }
' | jq -r .data.repository.pullRequests.nodes[].commits.nodes[].commit.oid)
```

Then cherry-pick these commits:

```shell
git cherry-pick ${COMMITS}
```

If there's a conflict, fix it. But if there's a conflict on package lockfiles such as `package-lock.json` or `yarn.lock`, don't try to fix it. Instead, run `npm i` or `yarn` to refresh lockfiles. Conflicts will automatically be fixed.

Finally, create a PR.

```shell
gh pr create --title "Dependabot rollup $(date +%Y-%m-%d)" --body "Consolidating [open dependabot PRs](https://github.com/${OWNER}/${REPO}/pulls/app%2Fdependabot)."
```

I do this in my team very often and it works well in most cases. Resolving conflicts is usually very straightforward.
