include Enumerable

class FeatureQuantifications

  def initialize(filename)
    @filename = filename
    @index_filename = "#{filename}.idx"
    @index = []
    begin
      filehander = File.open(@filename,'r')
    rescue
      raise "Can't open #{@filename}!"
    ensure
      filehander.close if filehander
    end
  end

  attr_accessor :filename, :index_filename, :index

  def save_index()
    entries{|e| @index << e} # e.pos}
    out = File.open(@index_filename,'w')
    out.puts(@index.join("\n"))
  end

  def entries(offset=nil)
    entry = nil
    filehandler = File.open(@filename, 'r')
    filehandler.pos = offset if offset
    while !filehandler.eof?
      pos = filehandler.pos
      line = filehandler.readline()

      break if line == ""

      line.chomp!

      if line =~ /----------/
        yield pos
      end
    end
    filehandler.close
  end

=begin
  def create_index()
    raise "#{@filename} is already indexed" unless @index == {}
    logger.info("Creating index for #{@filename}")
    last_gene = "unknown"
    last_position = 0
    @filehandle.rewind
    @filehandle.each do |line|
      line.chomp!
      if line =~ /GENE/
        last_gene = line.split("\t")[0]
        last_position = @filehandle.pos
      end
      if line =~ /transcript/
        fields = line.split("\t")
        chr = fields[1].split(":")[0]
        pos_chr = fields[1].split(":")[1].split("-")[0].to_i-1
        num_of_fragments = fields[-1].to_f
        @index[[chr,pos_chr,last_gene]] = [last_position,fields[-1].to_i] #if num_of_fragments > 0.0
      end
    end
    logger.info("Indexing of #{@index.length} transcripts complete")
  end

  def find_number_of_spliceforms()
    logger.info("Searching for number of spliceforms for #{@filename}")
    last_gene = "unknown"
    last_chr = ""
    last_highest_end = 0
    last_highest = 0
    last_position = 0
    current_number_of_spliceforms = 0
    current_transcripts = []
    @filehandle.rewind
    @filehandle.each do |line|
      line.chomp!
      if line =~ /GENE/
        last_gene = line.split("\t")[0]
        last_position = @filehandle.pos
      end
      if line =~ /transcript/
        fields = line.split("\t")
        chr = fields[1].split(":")[0]
        pos_chr = fields[1].split(":")[1].split("-")[0].to_i-1
        pos_chr_end = fields[1].split("-")[1].split("\t")[0].to_i
        current_transcripts << [chr,pos_chr,last_gene]
        current_number_of_spliceforms += 1
        if pos_chr_end > last_highest_end
          last_highest_end = pos_chr_end
        end
        if pos_chr > last_highest || chr != last_chr
          dummy = current_transcripts.delete_at(-1)
          current_transcripts.each do |transcript|
            @number_of_spliceforms[transcript] = current_number_of_spliceforms
          end
          current_transcripts = [dummy]
          current_number_of_spliceforms = 0
          last_chr = chr
          last_highest = last_highest_end
        end
      end
      current_transcripts.each do |transcript|
        @number_of_spliceforms[transcript] = current_number_of_spliceforms+1
      end
    end
  end

  def calculate_coverage(mio_reads=@m)
    @index.each_pair do |key,value|
      cov = fpkm_value(transcript(key),value[1],mio_reads)
      @coverage[key] = cov #if cov > 0
    end
  end

  def transcript(key)
    transcript = []
    value = @index[key]
    pos_in_file = value[0]
    @filehandle.pos = pos_in_file
    @filehandle.each do |line|
      break if line =~ /GENE/
      next unless line =~ /exon/
      line.chomp!
      transcript << line.split("-")[0].split(":")[1].to_i-1
      transcript << line.split("-")[1].split(" ")[0].to_i
    end
    transcript.sort!
  end

  def calculate_M()
    raise "M was already definied!" unless @m == 0
    logger.info("Calculating M for #{@filename}")
    @filehandle.rewind
    @filehandle.each do |line|
      line.chomp!
      if line =~ /transcript/
        fields = line.split("\t")
        @m += fields[-1].to_i
      end
    end
    @m = @m.to_f/1000000
    logger.info("M is #{@m}")
  end

  def determine_false_negatives(cutoff=500)
    @number_of_false_negatives = cutoff
    fn = @coverage.values.sort.reverse[0..cutoff]
    @coverage.each_pair do |key,value|
      @false_negatives[key] = value if fn.include?(value)
    end
  end

  def print_false_negatives()
    fn = @coverage.values.sort.reverse
    fn.each do |value|
      puts "#{value}"
    end
  end

  def frag_count(key)
    value = @index[key]
    frag_counts = value[1]
  end

  def fpkm_value(transcript,fragment,mio_reads=@m)
    trans_length = calc_length(transcript)
    raise "M needs to be definied!" if mio_reads == 0
    fpkm(fragment,trans_length,mio_reads)
  end
=end

end