"""
Vintage Numbers plugin for Sublime Text 2
by Ignacy Sokolowski
"""
import re
import sublime
import sublime_plugin


NUMBER_RE = re.compile(r'(-?0[0-7]+)|(-?0[xX][\da-fA-F]+)|(-?\d+)')


class ViNumberMixin(object):
    """Mixin for Sublime Text 2 TextCommands that enables incrementing
    and decrementing number at the caret position in Vintage command mode.
    It works with caret at any position of a number.

    Default key bindings are setup like in Vi:
        ctrl+a -- incrementing
        ctrl+x -- decrementing

    """

    def run(self, edit):
        new_sel = []
        int_method = getattr(int, self.int_method)
        for s in reversed(self.view.sel()):
            # Getting caret position.
            (row, col) = self.view.rowcol(s.begin())
            # Getting line at the caret.
            line = self.view.substr(
                        self.view.line(self.view.text_point(row, 0)))

            if not s.empty() or len(line) == 0:
                continue

            number = None

            # Searching for the first oct, hex or dec number in the line.
            matches = NUMBER_RE.finditer(line)
            for match in matches:
                beg, end = match.span()
                if col < end:
                    # This number is after the current carret position, getting
                    # it from the line.
                    number = line[beg:end]
                    # Checking number type to define converter and base.
                    # Base is deduced from the contents of the string the same
                    # way Python's function PyLong_FromString does it.
                    unsigned = number[1:] if number[0] == '-' else number
                    if unsigned == '0' or unsigned[0] != '0':
                        converter = int
                        base = 10
                    elif unsigned[1] in ('x', 'X'):
                        converter = hex
                        base = 16
                    else:
                        converter = oct
                        base = 8
                    break

            if not number:
                continue

            # Applying increment/decrement command to the number.
            new_number = str(converter(int_method(int(number, base), 1)))

            # Counting region that will be replaced.
            start = s.b - (col - beg)
            stop = s.b - (col - end)

            # Replacing number at the caret
            # with the incremented/decremented one.
            self.view.replace(edit, sublime.Region(start, stop), new_number)

            # Moving the caret to the end of the number.
            if len(number) == len(new_number):
                stop -= 1
            elif len(number) > len(new_number):
                stop -= 2
            new_sel.append(sublime.Region(stop, stop))

        if new_sel:
            self.view.sel().clear()
            for s in new_sel:
                self.view.sel().add(s)


class ViIncrementNumberCommand(sublime_plugin.TextCommand, ViNumberMixin):
    """Sublime Text 2 TextCommand to increment number at the caret position
    in Vintage command mode.
    It works with caret at any position of a number.

    Default key binding is setup to "ctrl+a" like in Vi.

    """
    int_method = '__add__'

    def run(self, edit):
        ViNumberMixin.run(self, edit)


class ViDecrementNumberCommand(sublime_plugin.TextCommand, ViNumberMixin):
    """Sublime Text 2 TextCommand to decrement number at the caret position
    in Vintage command mode.
    It works with caret at any position of a number.

    Default key binding is setup to "ctrl+x" like in Vi.

    """
    int_method = '__sub__'

    def run(self, edit):
        ViNumberMixin.run(self, edit)
