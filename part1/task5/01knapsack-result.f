Item = {Int, Int};

Inductive ItemList = cons {Item, ItemList} | nil Unit;

Plan = ItemList;

Inductive PlanList = consPlan {{Int, Int}, PlanList} | nilPlan Unit;

max = \x: Int. \y: Int. 
    if (< x y) then y
    else x;

step = \i: Item. 
    fix (
    \f: PlanList -> PlanList. \ps: PlanList. 
    match ps with
      consPlan {p, t} -> 
        let res = (f t) in 
            consPlan {let c0 = i.1 in 
                let c1 = i.2 in 
                    {+ p.1 c0, + p.2 c1}, consPlan {p, res}}
    | nilPlan _ -> ps
    end
);

gen = fix (
    \f: ItemList -> PlanList. \items: ItemList. 
    match items with
      cons {i, t} -> 
        let res = (f t) in 
            step i res
    | nil _ -> consPlan {{0, 0}, nilPlan unit}
    end
);

getbest = \lim: Int. 
    fix (
    \f: PlanList -> Int. \ps: PlanList. 
    match ps with
      consPlan {p, t} -> 
        let res = (f t) in 
            if (< lim (p.1)) then res
            else max (p.2) res
    | nilPlan _ -> 0
    end
);

knapsack = \w: Int. \is: ItemList. 
    getbest w (gen is);
