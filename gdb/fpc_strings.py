# gdb pretty-printer for Free Pascal strings.
#
# FPC describes AnsiString/ShortString/... in DWARF as a typedef of a char
# array. gdb's CLI prints them fine, but its DAP server only reports the array
# summary ('...' or empty) and exposes the characters as children, so
# nvim-dap-ui and nvim-dap-virtual-text show no value. Printing the whole
# string as a single value fixes that.

import gdb

FPC_STRING_TYPES = {
    "ANSISTRING",
    "SHORTSTRING",
    "UNICODESTRING",
    "WIDESTRING",
    "RAWBYTESTRING",
    "UTF8STRING",
    "STRING",
}


class FpcStringPrinter:
    def __init__(self, value):
        self.value = value

    def to_string(self):
        # raw=True skips pretty-printers, otherwise this printer would recurse
        return self.value.format_string(raw=True)


def lookup(value):
    name = value.type.name
    if name and name.upper() in FPC_STRING_TYPES:
        return FpcStringPrinter(value)
    return None


gdb.pretty_printers.append(lookup)
