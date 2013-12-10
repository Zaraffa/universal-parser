module Hooks
  def Hooks.included(into)    
    into.instance_methods(false).each { |m|            
      Hooks.hook_method(into, m) }
      def into.method_added(meth)
        unless @adding
          @adding = true
          Hooks.hook_method(self, meth)
          @adding = false          
        end
      end
  end
  
  def Hooks.hook_method(klass, meth)    
    nil if !klass::hooks.include? meth
    klass.class_eval do        
      alias_method "old_#{meth}", "#{meth}"
      modules = []
      Dir.foreach('./modules/') { |file|          
          next if file[0] == '.'                
          mod = eval file.gsub(/.rb/,'')          
          next unless mod::targets.include?klass.to_s                                      
          modules.push(mod) if mod.respond_to? meth                           
      }
      modules.sort! { |x,y| y::rate <=> x::rate }      
      define_method(meth) do |*args|                             
        modules.each do |mod|
          mod.send(meth,*args)
        end        
        self.send("old_#{meth}",*args)
      end
    end
  end
end