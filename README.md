# Blackbox GitHub Actions ![build](https://github.com/jrmcdonald/blackbox-github-actions/workflows/build/badge.svg)

Blackbox GitHub Actions allow you to execute [Blackbox](https://github.com/StackExchange/blackbox) commands within GitHub Actions.

### Success Criteria

An exit code of `0` is considered a successful execution.

## Usage

The most common workflow is to run `blackbox_postdeploy`, perform your actions using the decrypted secrets, and then run `blackbox_shred_all_files`.

This workflow requires two secrets to be configured for the repository:

* `BLACKBOX_PUBKEY` - the public key of an admin user for blackbox, ideally CI specific
* `BLACKBOX_PRIVKEY` - the private encryption sub key of an admin user for blackbox, ideally CI specific

The keys should be exported into ASCII armor format and then use the following command to prepare them for pasting into separate GitHub Secrets.

`cat -e <key file> | sed 's/\$/\\n/g'`

Note that the value provided to the `bb_actions_subcommand` input is the desired blackbox command with the `blackbox_` prefix stripped off.

```yaml
name: 'Blackbox GitHub Actions'
on:
  - pull_request
jobs:
  blackbox:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master

      - name: postdeploy
        uses: jrmcdonald/blackbox-github-actions@v0.2.0
        with:
          bb_actions_subcommand: 'postdeploy'
        env:
          BLACKBOX_PUBKEY: ${{ secrets.BLACKBOX_PUBKEY }}
          BLACKBOX_PRIVKEY: ${{ secrets.BLACKBOX_PRIVKEY }}

      - name: execute
        run: |
          # do something with the secrets here

      - name: shred
        uses: jrmcdonald/blackbox-github-actions@v0.2.0
        with:
          bb_actions_subcommand: 'shred_all_files'
        env:
          BLACKBOX_PUBKEY: ${{ secrets.BLACKBOX_PUBKEY }}
          BLACKBOX_PRIVKEY: ${{ secrets.BLACKBOX_PRIVKEY }}

```