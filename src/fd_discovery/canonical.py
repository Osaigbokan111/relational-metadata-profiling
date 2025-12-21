from typing import List, Tuple


def is_redundant_fd(fd, fds):
    X, A = fd
    reduced = [f for f in fds if f != fd]
    return A in attribute_closure(X, reduced)

def canonical_cover(fds: List[Tuple[List[str], str]]):
    current_fds = {(tuple(sorted(X)), A) for X, A in fds}

    changed = True
    while changed:
        changed = False
        minimized = set()

        for X, A in current_fds:
            X = list(X)
            for attr in X[:]:
                trial = [x for x in X if x != attr]
                if trial and A in attribute_closure(trial, list(current_fds)):
                    X = trial
                    changed = True
            minimized.add((tuple(sorted(X)), A))

        current_fds = minimized
        non_redundant = set()

        for fd in current_fds:
            if not is_redundant_fd(fd, list(current_fds)):
                non_redundant.add(fd)
            else:
                changed = True

        current_fds = non_redundant

    return [(list(X), A) for X, A in sorted(current_fds)]
