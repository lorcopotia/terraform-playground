# Settings

## Update qemu.conf

Uncomment the line:
```
security_driver = "none"
```

## Creating bridge network for KVM

Create a file named br0.xml for KVM using vi command or cat command:
```
cat /tmp/virsh_host-bridge.xml
```
Append the following code:
```
<network>
  <name>br0</name>
  <forward mode="bridge"/>
  <bridge name="br0" />
</network>
```

Run virsh command as follows:
```
virsh net-define /tmp/virsh_host-bridge.xml
virsh net-start br0
virsh net-autostart br0
virsh net-list --all
```
