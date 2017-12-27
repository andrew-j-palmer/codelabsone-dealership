input = ARGV[0]

  if /[[:digit:]]/.match(input) != nil
	puts /[[:digit:]]/.match(input)
	puts "at least 1 number"
    if /[[:alpha:]]/.match(input) == nil
	puts /[[:alpha:]]/.match(input)
	puts "no letters"
      puts true
    end
  else
    puts false
  end
