def attribute_closure(X, fds):
    closure = set(X)
    changed = True
    while changed:
        changed = False
        for lhs, rhs in fds:
            if set(lhs).issubset(closure) and rhs not in closure:
                closure.add(rhs)
                changed = True
    return closure
