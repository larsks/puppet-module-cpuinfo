require 'facter'

cpuinfo_text = open('/proc/cpuinfo').read
cpuinfo = {}
cur = nil
cpuinfo_text.each_line do |line|
    if line.include? ':'
        k,v = line.split(':')
        k = k.strip.gsub(' ', '_')
        v = v.strip

        if k == 'processor'
            cur = {}
            cpuinfo["processor#{v}"] = cur
        end

        cur[k] = v

        if k == 'flags'
            v.split().each do |flag|
                cur["flag_#{flag}"] = 1
            end
        end
    end
end

cpuinfo.each do |cpu, cpudata|
    cpudata.each do |k,v|
        Facter.add("#{cpu}_#{k}") do
            setcode do
                v
            end
        end
    end
end
