require 'facter'

cpuinfo_text = open('/proc/cpuinfo').read
cpuinfo = {}
cur = nil
cpuinfo_text.each_line do |line|
    if line.include? ':'
        k,v = line.split(':')
        k = k.strip.gsub(' ', '_')
        v = v.strip

        # Facts for each processor are stored under the
        # processorN key.
        if k == 'processor'
            cur = {}
            cpuinfo["processor#{v}"] = cur
        end

        cur[k] = v

        # Split CPU flags into individual facter facts.  These will 
        # be named things like processor0_flag_fpu and will have the
        # value '1'.
        if k == 'flags'
            v.split().each do |flag|
                cur["flag_#{flag}"] = 1
            end
        end
    end
end

cpuinfo.each do |cpu, cpudata|
    cpudata.each do |k,v|
        # Each fact will named processorN_FACT
        # (e.g., processor0_vendor_id)
        Facter.add("#{cpu}_#{k}") do
            setcode do
                v
            end
        end
    end
end
