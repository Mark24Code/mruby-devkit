# This sample displays the following UI:
#
# ┌─────────────────────────────────────────────────────────────┐
# │Window #1                                                    │
# │ ┌─────────────────────────────────────────────────────────────┐
# │ │Window #2                                                    │
# │ │                                                             │
# │ │                                                             │
# │ │                                                             │
# │ │                                                             │
# │ │                                                             │
# │ │                                                             │
# │ │                                                             │
# │ │                                                             │
# │ │                                                             │
# │ │                                                             │
# │ │                                                             │
# │ │                                                             │
# │ │                                                             │
# └─│                                                             │
#   │                                                             │
#   └─────────────────────────────────────────────────────────────┘
#
# Press tab to swap focus between windows.
# Press ctrl-c to exit.

CUI.init

$w1 = CUI::Window.new(lines: 10, cols: 10)
class << $w1
  def render
    return unless @invalid
    io.goto(1, 1);
    io.write_line_right('Window #1')
    io.box()
  end
end

$w2 = CUI::Window.new(lines: 10, cols: 10)
class << $w2
  def render
    return unless @invalid
    io.goto(1, 1);
    io.write_line_right('Window #2')
    io.box()
  end
end

CUI.screen.add_children($w1, $w2)

class << CUI.screen
  def layout
    dim = [(CUI.screen.maxy / 2).to_i, (CUI.screen.maxx / 2).to_i]
    @children[0].mv(2, 2)
    @children[0].resize(*dim)
    @children[1].mv(4, 4)
    @children[1].resize(*dim)
  end
end

def swap
  $w1.focused? ? $w2.focus : $w1.focus
end

CUI.on(CUI::KeyEvent) do |k|
  if k.keyname == '^C'
    CUI::EventLoop.exit
  elsif k.key == "\t".ord
    swap
  end
end
CUI.run
