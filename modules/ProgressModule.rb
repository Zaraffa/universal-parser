module ProgressModule
  @@time,@@prev,@@count,@@dif = nil
  @@difs = []
  @@progress = 0
  @@counter = 0
  @@rate = 10
  @@targets = %w[Parser]
  
  def self.targets
    @@targets
  end
  
  def self.rate
    @@rate
  end  
  
  def self.pre_parse *args
    @@count = args.first
  end

  def self.each_parse *args
    @@counter+=1
    @@count-=1
    @@prev = @@time if @@time
    @@time = Time.now
    @@difs.push @@time-@@prev if (@@prev && @@time && @@counter<11)
    @@dif = @@difs.inject{ |sum, el| sum + el }.to_f / @@difs.size if(@@counter>11 && !@@dif)                
    p @@count.to_s+" documents left "+((@@count - @@counter).to_f*@@dif).to_s + " Left " if @@counter%10==0 && @@dif    
    p "Done!" if @@count==0    
  end
end