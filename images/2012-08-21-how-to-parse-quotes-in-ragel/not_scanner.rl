examples = [
  %{''},
  %{""},
  %{' '},
  %{" "},
  %{'A'},
  %{'ABC'},
  %{'AB C'},
  %{'A B  C'},
  %{'AB\\\'C'},
  %{'A\\\'B\\\'C'},
  %{'A \\\'B \\\' C'},
  %{ ' A . B . C ' },
  %{ ' A \\\'. B \\\'. \\\'C ' },
  %{ " hello " },
  %{ " hello 'world' " },
  %{ ' hello "world" ' },
]

=begin
%%{
  machine not_scanner;

  action Start {
    s = p
  }
  action Stop {
    puts '=> ' + data[(s)...(p)].pack('c*').inspect
  }

  squote = "'";
  dquote = '"';
  not_squote_or_escape = [^'\\];
  not_dquote_or_escape = [^"\\];
  escaped_something = /\\./;
  ss = space* squote ( not_squote_or_escape | escaped_something )* >Start %Stop squote;
  dd = space* dquote ( not_dquote_or_escape | escaped_something )* >Start %Stop dquote;

  main := (ss | dd)*;
}%%
=end

class Bar
  def initialize
    %% write data;
    # % (this fixes syntax highlighting)
  end

  def parse(str)
    data = str.unpack('c*')
    p = 0
    pe = eof = data.length
    %% write init;
    # % (this fixes syntax highlighting)
    %% write exec;
    # % (this fixes syntax highlighting)
  end
end

bar = Bar.new
examples.each do |input|
  $stdout.write input.inspect.ljust(30)
  bar.parse input
  puts
end
