## Creating bridge network for KVM

Create a file named br0.xml for KVM using vi command or cat command:
```
cat /tmp/br0.xml
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
virsh net-define /tmp/br0.xml
virsh net-start br0
virsh net-autostart br0
virsh net-list --all
```
