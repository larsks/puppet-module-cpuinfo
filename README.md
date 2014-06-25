This module exports everything in `/proc/cpuinfo` as a Facter fact,
and it breaks out the individual CPU flags into separate facts.  For
example, you can do this:

    if $processor0_flag_vmx or $processor0_flag_svm {
      notify {"We have kvm available!":}
    } else {
      notify {"Woe is us we must use qemu.":}
    }


