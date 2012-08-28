#!/usr/bin/env ruby
# WhiteSpace Generator
# 標準入力からプログラムを読み込み、標準出力にWhitespaceプログラムを出力する
@command = [
  ["PUSH", "SS", "d"],
  ["POP","SLS",""],
  ["COPY","STS","d"],
  ["SWAP","SLT",""],
  ["DISCARD","SLL",""],
  ["SLIDE","STL",""],
  
  ["ADD","TSSS",""],
  ["SUB","TSST",""],
  ["MUL","TSSL",""],
  ["DIV","TSTS",""],
  ["MOD","TSTT",""],

  ["STORE", "TTS", ""],
  ["RETRIEVE", "TTT", ""],

  ["LABEL", "LSS", "l"],
  ["CALL", "LST", "l"],
  ["JUMP", "LSL", "l"],
  ["JUMPIFZERO", "LTS", "l"],
  ["JUMPIFNEG", "LTT", "l"],
  ["RET", "LTL", ""],
  ["END", "LLL", ""],

  ["PUTCHAR", "TLSS", ""],
  ["PUTINT", "TLST", ""],
  ["GETCHAR", "TLTS", ""],
  ["GETINT", "TLTT", ""],
]

@chars = {"T" => "\t", "L" => "\n", "S" => " "}

@labels = {}
def get_number(number)
  ret = ""
  if number >= 0
    ret = "S"
  else
    ret = "T"
    number = -number
  end
  ret += number.to_s(2).gsub("1","T").gsub("0","S")
  return ret + "L"
end

def get_labal(label)
  unless @label.key?(label)
    tar = @label.size + 1
    @label[key] = tar
  end
  return get_number(@label[key])
end

def show_error(line, mes)
  STDERR.puts "Warning on line #{line}: #{mes}"
end
command = ""

program = ""
line = 0
while command = gets
  command.strip!
  line += 1
  next if /^#.*/ =~ command
  cmd,param = "", ""
  if /^(.+?)\s+(.+?)$/ =~ command
    cmd = $1
    param = $2
  elsif /^(.+)$/ =~ command
    cmd = $1
  end
  next if cmd == ""
  match = false
  @command.each do |command|
    if cmd.upcase == command[0]
      program << command[1]
      if command[2] != "" && param == ""
        show_error line, "Require Parameter"
      end
      if command[2] == "d"
        program << get_number(param.to_i)
      elsif command[2] == "l"
        program << get_label(param)
      end
      match = true
    end
  end
  unless match
    show_error line, "No Such Command #{cmd}"
  end
end
@chars.each do |k,v|
  program.gsub!(k,v)
end
print program
