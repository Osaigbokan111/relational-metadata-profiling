from itertools import combinations
from typing import List
import pandas as pd

def is_minimal_fd(df: pd.DataFrame, X: List[str], A: str) -> bool:
    for size in range(1, len(X)):
        for subset in combinations(X, size):
            groups = df.groupby(list(subset))[A].nunique()
            if (groups <= 1).all():
                return False
    return True

def discover_minimal_fds(df, discover_fds_fn, max_size=3):
    for X, A in discover_fds_fn(df, max_size):
        if is_minimal_fd(df, X, A):
            yield (X, A)
