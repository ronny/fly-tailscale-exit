Run Tailscale exit nodes on Fly.

Based on https://github.com/patte/fly-tailscale-exit

## Install

1. Set up a **reusable** Tailscale auth key https://login.tailscale.com/admin/settings/authkeys — copy the key somewhere safe before
   closing the pop-up window, Tailscale won't show it again.
2. `fly launch` — follow the prompts but don't deploy just yet. `fly ips allocate-v6` (or v4) if it's complaining about needing an IP.

		```
		? fly.toml file already exits would you like copy its configuration : (yes/no) yes
		? App Name (leave blank to use an auto-generated name) ronny-tailscale-exit
		? No postgresql
		? No Redis
		? would you like to deploy now : (yes/no) no
		```

3. `fly secrets set TAILSCALE_AUTHKEY="..."`
4. `fly deploy`
5. Go to [Tailscale Admin](https://login.tailscale.com/admin/machines), find the new node, note the (i) warning icon next to "Exit Node", click on "...", then "Edit route settings...", turn on "Exit node".
6. Use the exit node.

See https://github.com/patte/fly-tailscale-exit for more tips.

## Suspend

fly scale count 0
fly ips list
fly ips release ...

## Resume

Edit [Dockerfile](Dockerfile) if you want the latest version.

Check https://login.tailscale.com/admin/settings/keys to see if the Tailscale
Auth Key has expired, if it has, then generate a new reusable auth key, then
update the secret with:

```
fly secrets set TAILSCALE_AUTHKEY="tskey-auth-...."
```

Then:

```
fly ips allocate-v6
fly deploy
fly scale count 1
```
