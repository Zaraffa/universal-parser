module JapaneeseModule

  @@japs = ["An Eastern poet, Ali Ben Abu Taleb, writes with sad truth, 'He who has a thousand friends has not a friend to spare, And he who has one enemy shall meet him everywhere'",           
            'When people grieve, share their sorrow ',
            'When people are glad join them ',
            'Good and evil are in your heart',
            'Horse stamina is tested in road, human character-only with time',
            'Talents are not inherited ',
            'Servant like falcon needs nurture ',
            'Soul of person in three years is the same after hundred ',
            'Modesty beats power',
            'Humanity begins with compassion'
            ]
  
  @@rate = 9
  @@targets = %w[Parser]
  
  def self.targets
    @@targets
  end
  
  def self.rate
    @@rate
  end
  
  def self.each_parse *args
    p @@japs[rand(@@japs.size)]+"..." if (rand(100)==5)   
  end
end