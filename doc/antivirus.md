# Antivirus Installation

## Steps

### 1. ClamAV and daemon installation

```bash
sudo apt install clamav clamav-daemon
```

### 2. ClamAV configuration

```
# Change the following from /etc/clamav/freshclam.conf
# Change `local` to your country code
DatabaseMirror db.local.clamav.net
```

This didn't work for me:

```
# Change the following from /etc/clamav/clamd.conf
# Most Rails apps use symlinks in the production environment
FollowDirectorySymlinks true
FollowFileSymlinks true
```

### 3. AppArmor configuration for clamd (Not needed for new ruby image)

Make sure that the folder where your application is running is included in the
readable directories list:

```bash
sudo less /etc/apparmor.d/usr.sbin.clamd
```

If not, edit the local AppArmor configuration:

```bash
sudo nano /etc/apparmor.d/local/usr.sbin.clamd
```

Add the following line there with your application directory:

```
# Allow scanning for the application subdirs
/path/to/your/app/** r,
```

And finally reload apparmor configuration:

```bash
sudo systemctl reload apparmor
```

### 4. Restart ClamAV daemons

```bash
sudo systemctl restart clamav-freshclam
sudo systemctl restart clamav-daemon
```

## Test setup

- ```bash
  cd /path/to/your/app
  echo 'This is clean' > clean.pdf
  wget -O dirty.pdf https://secure.eicar.org/eicar.com

  ```

- Go to your application folder and create simple test files there to test the
virus scanning:

  ```bash

  cd /path/to/your/app
  echo 'This is clean' > clean.pdf
  wget -O dirty.pdf https://secure.eicar.org/eicar.com

  ```

  The file `dirty.pdf` fetched from the URL is an
  [EICAR test file](https://en.wikipedia.org/wiki/EICAR_test_file) used to test
  the response of the antivirus scan.

- Run the antivirus tests for both of these files using `clamdscan`:

  ```bash

  clamdscan clean.pdf dirty.pdf

  ```

- You should see the following type of output from that command when ClamAV and
its daemon are correctly working:

  ```

  /path/to/your/app/clean.pdf: OK
  /path/to/your/app/dirty.pdf: Eicar-Test-Signature FOUND

  ----------- SCAN SUMMARY -----------
  Infected files: 1
  Time: 0.001 sec (0 m 0 s)

  ```

- `bundle exec rails ratonvirus:test`
