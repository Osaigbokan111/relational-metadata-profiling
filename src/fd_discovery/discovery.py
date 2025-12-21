import pandas as pd
from typing import List, Tuple, Iterator
from itertools import combinations

def is_fd(df: pd.DataFrame, X: List[str], A: str) -> bool:
    groups = df.groupby(X)[A].nunique()
    return (groups <= 1).all()

def level_wise_candidates(columns: List[str], max_size: int):
    for size in range(1, max_size + 1):
        for combo in combinations(columns, size):
            yield list(combo)

def discover_fds(df: pd.DataFrame, max_size: int = 3):
    columns = list(df.columns)
    for X in level_wise_candidates(columns, max_size):
        for A in columns:
            if A not in X and is_fd(df, X, A):
                yield (X, A)
