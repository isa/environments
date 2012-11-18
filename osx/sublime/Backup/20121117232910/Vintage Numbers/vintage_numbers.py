"""
Vintage Numbers plugin for Sublime Text 2
by Ignacy Sokolowski
"""
import re
import sublime
import sublime_plugin


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
            # Find all numbers in the line.
            matches = re.finditer('(-?\d+)', line)

            number = None
            for match in matches:
                beg, end = match.span()
                # This number is after the current carret position.
                if col < end:
                    number = line[beg:end]
                    break

            if not number:
                continue

            # Apply increment/decrement command to the number.
            new_number = str(int_method(int(number), 1))

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
