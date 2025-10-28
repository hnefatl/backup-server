# Backup Server

## OCI Configuration

OCI (Oracle Cloud Infrastructure).

1.  ```sh
    $ nix shell nixpkgs#openssl
    $ openssl genrsa -out ~/.oci/id.pem 4096
    $ chmod 600 ~/.oci/id.pem
    $ openssl genrsa -out ~/.oci/id.pem 4096
    $ openssl rsa -pubout -in ~/.oci/id.pem -out ~/.oci/id_public.pem
    $ cat ~/.oci/id_public.pem
    ```

1.  Then paste into https://cloud.oracle.com/identity/domains/my-profile/auth-tokens?region=uk-london-1.

1.  Then paste _that_ into `~/.oci/config`.

1.  Create a file called `terraform.tfvars` in this repository (it's gitignored) containing any variable values needed.

## Creation

```sh
$ ./init.sh
```