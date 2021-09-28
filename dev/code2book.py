#!/usr/bin/env python3
import os
import sys
import art
from os.path import join, split


class CppProject(object):

    def __init__(self, home, project, name):
        self.project = project
        self.benchmark = join(home, "benchmark")
        self.test = join(home, "test")
        self.src = join(home, "src")
        self.book = join(".", name)
        self.ignored = [".txt"]

    def __ignored(self, name):
        for ignore in self.ignored:
            if name.endswith(ignore):
                return True
        return False

    def extract(self):
        paths = []
        entries = {}
        print("Scanning source codes...")
        self.__scan_files(self.src, split(self.src)[-1], paths, entries)
        self.__scan_files(self.test, split(self.test)[-1], paths, entries)
        self.__scan_files(self.benchmark, split(self.benchmark)[-1], paths, entries)
        paths = sorted(paths)
        print("Collecting source codes: ", end="")
        with open(self.book, mode="w") as book:
            if self.project != "":
                book.write("\n\n\n\n\n")
                book.write(art.text2art(self.project))
                book.write("\n\n\n\n\n")
            for path in paths:
                print(".", end="")
                entry = entries[path]
                if entry is None:
                    continue
                book.writelines(["\n\n===== " + path + " =====\n"])
                with open(entry, mode="r") as file:
                    lines = file.readlines()
                    book.writelines(lines)
                    book.flush()
        print("Done")

    def __scan_files(self, cur: str, path: str, paths: [], entries: {}, is_include=False):
        """
        Scan the source code files from the project base directory
        :return:
        """
        for dirpath, dirs, files in os.walk(cur):
            for directory in dirs:
                child = ""
                if path != "":
                    child = path
                if directory == "include":
                    self.__scan_files(join(dirpath, directory), child, paths, entries, is_include=True)
                else:
                    child = join(child, directory)
                    self.__scan_files(join(dirpath, directory), child, paths, entries)
            for file in files:
                if self.__ignored(file):
                    continue
                paths.append(join(path, file))
                entries[join(path, file)] = join(dirpath, file)


def main():
    home = sys.argv[1]
    name = "books/book.txt"
    project = ""
    if len(sys.argv) == 3:
        project = sys.argv[2]
        name = join("books", project + ".txt")
    elif len(sys.argv) == 4:
        project = sys.argv[2]
        name = sys.argv[3]
    cpp = CppProject(home, project, name)
    cpp.extract()


def usage():
    print("""
    code2book.py [home] [project] [name]
    
        home        Home directory of the project
        project     Name of the project
        name        Name of the produced book
    """)


if __name__ == '__main__':
    if len(sys.argv) > 4 or len(sys.argv) < 2:
        usage()
        exit(0)
    main()