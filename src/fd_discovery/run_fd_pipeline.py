df = pd.read_csv("data/raw/vw_airport_geograph.csv")

fds = list(discover_minimal_fds(df, discover_fds))
canonical_fds = canonical_cover(fds)

for X, A in canonical_fds:
    print(f"{X} -> {A}")
