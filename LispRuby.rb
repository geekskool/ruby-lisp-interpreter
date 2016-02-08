#take input from user
#add spaces in ) and( with gsub
#split them into tokens of individual units
#make syntax tree out of it  using norvig's read_from_tokens recursive method
#write a function to convert each element to int, float and symbol using regexp
#Check the parser
########## Parsing completes here ####################
#create environment to process the eval
#write eval function to calculate mathematical operation
#upadate the car, cdr, cons
#update with null? max min eq?
#update with lambda

class LispRuby

    def initialize

        @environment = {

            :+     => lambda{|*list| list.inject{|sum,x| sum + x }},
      	    :==    => lambda{|x, y| x == y},
      	    :!=    => lambda{|x, y| x != y},
      	    :<     => lambda{|x, y| x < y},
      	    :<=    => lambda{|x, y| x <= y},
      	    :>     => lambda{|x, y| x > y},
      	    :>=    => lambda{|x, y| x >= y},
      	    :*     => lambda{|*list| list.inject(1){|prod, x| prod * x}},
      	    :/     => lambda{|x, y| x / y},
      	    :-     => lambda{|x, y| x - y},

      	    :list  => lambda{|*list| Array(list)},
      	    :eq?   => lambda{|x, y| x == y},
      	    :min   => lambda{|list| list.min},
      	    :max   => lambda{|list| list.max},
      	    :sqrt  => lambda{|x| Math.sqrt(x)},
      	    :pow   => lambda{|x, y| x**y},
          	
            :car   => lambda{|list|},
            :cdr   => lambda{|list|},
            :cons  => lambda{|e, list|},
	      }

    end

    ################# USER INPUT ##################

    def user_input
        while true
      	    print "LispRuby >> "
      	    lisp_command = gets.chomp
      	    break if lisp_command.downcase == "exit"
            result = run_the lisp_command
      	    puts (result.inspect) unless result.nil?
    	  end
    end 	
 
    ################# PARSING STARTS ################

    def run_the lisp
        eval make_syntax seperate lisp
    end

    def seperate input_from_user
        raise SyntaxError, "Empty input" if input_from_user.empty?
        raise SyntaxError, "Unexpected ')' or '(" if ((input_from_user.count '(') != (input_from_user.count ')'))
        input_from_user.gsub('(', ' ( ').gsub(')', ' ) ').split(" ")
    end

    def make_syntax tokens
        token = tokens.shift
        if '(' == token 
      	    list = []
      	    while tokens.first != ')'
            list << make_syntax(tokens)
     	      end
      	    tokens.shift
      	    list
   	    elsif ')' == token
      	    raise 'Wrong Syntax'
    	  else
      	    check token
    	  end   	
    end

    def check token
        if token[/\.\d+/]
      	    token.to_f
        elsif token[/\d+/]
      	    token.to_i
    	  else
            token.to_sym
    	  end
    end
    
    ################# PARSING COMPLETED ##################

    ################# EVALUATION STARTS ##################

    def eval (exp, env = @environment)
        if exp.is_a? Numeric
            exp
        elsif exp.is_a? Symbol
            env[exp]
        elsif exp.first == :quote
      	    exp[1..-1]
        elsif exp.first == :if
            _, condition, yes, no = exp
            exp = eval(condition, env) ? yes : no
            eval(exp, env)
        elsif exp.first == :define
            _, var, e = exp
            env[var] = eval(e, env)
        elsif exp.first == :lambda
            _, params, e = exp
            lambda { |*args| eval(e, env.merge(Hash[params.zip(args)])) }
        else    		  
            car_cdr_cons(exp) if exp.first == :car || :cdr || :cons
            proc = eval(exp[0], env)
            args = exp[1..-1].map{ |arg| eval(arg, env) }
            proc.(*args)
        end
    end

    def car_cdr_cons(expression)
        start = expression.first
        case start
    	      when :car
	          puts expression.flatten[2].inspect
	    
	          when :cdr
	          puts expression.flatten[3..-1].inspect

	          when :cons		
	          puts (expression.flatten[3..-1] << expression.flatten[1]).inspect		
        end        
    end
end

    ################# EVALUATION COMPLETED ##############

    ################# INVOKING PROGRAM ##################

invoke = LispRuby.new
invoke.user_input