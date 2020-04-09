# Blackbox GitHub Actions

Blackbox GitHub Actions allow you to execute [Blackbox](https://github.com/StackExchange/blackbox) commands within GitHub Actions.

### Success Criteria

An exit code of `0` is considered a successful execution.

## Usage

The most common workflow is to run `blackbox_postdeploy`, perform your actions using the decrypted secrets, and then run `blackbox_shred_all_files`.

This workflow requires two secrets to be configured for the repository:

* `CI_GPG_PUBKEY` - the public key of an admin user for blackbox, ideally CI specific
* `CI_GPG_SUBKEY` - the private encryption sub key of an admin user for blackbox, ideally CI specific

The keys should be exported into ASCII armor format and then use the following command to prepare them for pasting into separate GitHub Secrets.

`cat -e <key file> | sed 's/\$/\\n/g'`

Note that the value provided to the `bb_actions_subcommand` input is the desired blackbox command with the `blackbox_` prefix stripped off. Also, the `GNUPGHOME` environment variable should be set.

```yaml
name: 'Blackbox GitHub Actions'
on:
  - pull_request
jobs:
  blackbox:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: set GNUPGHOME
        run: |
          echo ::set-env name=GNUPGHOME::"${GITHUB_WORKSPACE}/.gnupg"
      - name: gpg setup
        run: |
          echo -e "${{ secrets.CI_GPG_PUBKEY }}" | gpg --import
          echo -e "${{ secrets.CI_GPG_SUBKEY }}" | gpg --import
          gpg --list-keys
          gpg --list-secret-keys

      - name: postdeploy
        uses: jrmcdonald/blackbox-github-actions@v0.1.4
        with:
          bb_actions_subcommand: 'postdeploy'

      - name: execute
        run: |
          # do something with the secrets here

      - name: shred
        uses: jrmcdonald/blackbox-github-actions@v0.1.4
        with:
          bb_actions_subcommand: 'shred_all_files'
```