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
  machine scanner;

  action GotOne {
    puts '=> ' + data[(ts+1)...(te-1)].pack('c*').inspect
  }

  squote = "'";
  dquote = '"';
  not_squote_or_escape = [^'\\];
  not_dquote_or_escape = [^"\\];
  escaped_something = /\\./;

  main := |*
    squote ( not_squote_or_escape | escaped_something )* squote => GotOne;
    dquote ( not_dquote_or_escape | escaped_something )* dquote => GotOne;
    any;
  *|;
}%%
=end

require 'stringio'

class Foo
  CHUNK_SIZE = 1

  def initialize
    %% write data;
    # % (this fixes syntax highlighting)
  end

  def parse(str)
    f = StringIO.new str

    # So that ragel doesn't try to get it from data.length
    pe = :ignored
    eof = :ignored

    %% write init;
    # % (this fixes syntax highlighting)

    leftover = []

    while chunk = f.read(CHUNK_SIZE)
      data = leftover + chunk.unpack('c*')
      p ||= 0
      pe = data.length

      %% write exec;
      # % (this fixes syntax highlighting)
      if ts
        leftover = data[ts..pe]
        p = p - ts
        ts = 0
      else
        leftover = []
        p = 0
      end
    end
  end
end

foo = Foo.new
examples.each do |input|
  $stdout.write input.inspect.ljust(30)
  foo.parse input
  puts
end
