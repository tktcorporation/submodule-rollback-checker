set shell := ["bash", "-c"]


act:
    act --version
test-pull-request:
    act pull_request -e events/pull_request.json -s GITHUB_TOKEN=${GH_TOKEN}
