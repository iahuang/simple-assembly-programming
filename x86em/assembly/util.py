import pkg_resources

def rcut(string, pattern):
    if string.endswith(pattern):
        return string[:-len(pattern)]
    return string

def lcut(string, pattern):
    if string.startswith(pattern):
        return string[len(pattern):]
    return string

def resource_path(relative):
    return pkg_resources.resource_filename(__name__, relative)