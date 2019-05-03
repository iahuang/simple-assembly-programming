def rcut(string, pattern):
    if string.endswith(pattern):
        return string[:-len(pattern)]
    return string

def lcut(string, pattern):
    if string.startswith(pattern):
        return string[len(pattern):]
    return string