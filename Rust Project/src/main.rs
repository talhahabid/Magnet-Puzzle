#![allow(non_snake_case,non_camel_case_types,dead_code)]

/*
    Fill in the polarity function below. Use as many helpers as you want.
    Test your code by running 'cargo test' from the tester_rs_simple directory.
    
*/

fn polarity(board: &[&str], specs: &(Vec<i32>, Vec<i32>, Vec<i32>, Vec<i32>)) -> Vec<String> {
    let rows = board.len();
    let cols = board[0].len();
    let initial_solution = initialize_solution(rows, cols);
    let mut magnet_pairs = find_magnet_pairs(board);
    sort_pairs_by_constraints(&mut magnet_pairs, specs, rows, cols);
    let constraint_state = initialize_constraints(rows, cols, specs);

    match solve_with_pairs(board, initial_solution, &magnet_pairs, constraint_state) {
        Some(solution) => solution,
        None => panic!("No solution found"),
    }
}

#[derive(Clone)]
struct ConstraintState {
    rows: usize,
    cols: usize,
    plus_rows: Vec<i32>,
    minus_rows: Vec<i32>,
    plus_cols: Vec<i32>,
    minus_cols: Vec<i32>,
    left_constraints: Vec<i32>,
    right_constraints: Vec<i32>,
    top_constraints: Vec<i32>,
    bottom_constraints: Vec<i32>,
}

fn initialize_solution(rows: usize, cols: usize) -> Vec<String> {
    vec![String::from("X").repeat(cols); rows]
}

fn initialize_constraints(rows: usize, cols: usize, specs: &(Vec<i32>, Vec<i32>, Vec<i32>, Vec<i32>)) -> ConstraintState {
    ConstraintState {
        rows,
        cols,
        plus_rows: vec![0; rows],
        minus_rows: vec![0; rows],
        plus_cols: vec![0; cols],
        minus_cols: vec![0; cols],
        left_constraints: specs.0.clone(),
        right_constraints: specs.1.clone(),
        top_constraints: specs.2.clone(),
        bottom_constraints: specs.3.clone(),
    }
}

fn find_magnet_pairs(board: &[&str]) -> Vec<((usize, usize), (usize, usize))> {
    let rows = board.len();
    let cols = board[0].len();
    let mut pairs = Vec::new();
    
    for r in 0..rows {
        for c in 0..(cols-1) {
            let left_tile = board[r].chars().nth(c).unwrap();
            let right_tile = board[r].chars().nth(c+1).unwrap();
            if left_tile == 'L' && right_tile == 'R' {
                pairs.push(((r, c), (r, c+1)));
            }
        }
    }


    for r in 0..(rows-1) {
        for c in 0..cols {
            let top_tile = board[r].chars().nth(c).unwrap();
            let bottom_tile = board[r+1].chars().nth(c).unwrap();
            if top_tile == 'T' && bottom_tile == 'B' {
                pairs.push(((r, c), (r+1, c)));
            }
        }
    }
    
    pairs
}

fn constraint_score(constraints: &[i32], index: usize) -> i32 {
    if constraints[index] != -1 { 2 } else { 0 }
}

fn sort_pairs_by_constraints(
    pairs: &mut Vec<((usize, usize), (usize, usize))>,
    specs: &(Vec<i32>, Vec<i32>, Vec<i32>, Vec<i32>),
    rows: usize,
    cols: usize,
) {
    let center_r = (rows - 1) as f64 / 2.0;
    let center_c = (cols - 1) as f64 / 2.0;
    pairs.sort_by(|&((r1, c1), (r2, c2)), &((r3, c3), (r4, c4))| {
        let score1 = calculate_pair_score(r1, c1, r2, c2, specs, rows, cols, center_r, center_c);
        let score2 = calculate_pair_score(r3, c3, r4, c4, specs, rows, cols, center_r, center_c);
        // Reverse order to have highest priority first
        score2.cmp(&score1)
    });
}

fn calculate_pair_score(
    r1: usize, c1: usize, r2: usize, c2: usize,
    specs: &(Vec<i32>, Vec<i32>, Vec<i32>, Vec<i32>),
    rows: usize, cols: usize,
    center_r: f64, center_c: f64
) -> i32 {
    let row_score1 = constraint_score(&specs.0, r1) + constraint_score(&specs.1, r1);
    let col_score1 = constraint_score(&specs.2, c1) + constraint_score(&specs.3, c1);
    let row_score2 = constraint_score(&specs.0, r2) + constraint_score(&specs.1, r2);
    let col_score2 = constraint_score(&specs.2, c2) + constraint_score(&specs.3, c2);
    
    let edge_priority1 = if r1 == 0 || r1 == rows - 1 || c1 == 0 || c1 == cols - 1 { 10 } else { 0 };
    let edge_priority2 = if r2 == 0 || r2 == rows - 1 || c2 == 0 || c2 == cols - 1 { 10 } else { 0 };
    
    let actual_constraint_value = 
        (if specs.0[r1] != -1 { specs.0[r1] } else { 0 }) +
        (if specs.1[r1] != -1 { specs.1[r1] } else { 0 }) +
        (if specs.0[r2] != -1 { specs.0[r2] } else { 0 }) +
        (if specs.1[r2] != -1 { specs.1[r2] } else { 0 }) +
        (if specs.2[c1] != -1 { specs.2[c1] } else { 0 }) +
        (if specs.3[c1] != -1 { specs.3[c1] } else { 0 }) +
        (if specs.2[c2] != -1 { specs.2[c2] } else { 0 }) +
        (if specs.3[c2] != -1 { specs.3[c2] } else { 0 });
    
    row_score1 + col_score1 + row_score2 + col_score2 +
    edge_priority1 + edge_priority2 +
    ((center_r - r1 as f64).abs() + (center_c - c1 as f64).abs() +
     (center_r - r2 as f64).abs() + (center_c - c2 as f64).abs()) as i32 +
    (actual_constraint_value / 2) 
}

fn solve_with_pairs(
    _board: &[&str],
    solution: Vec<String>,
    pairs: &[((usize, usize), (usize, usize))],
    state: ConstraintState
) -> Option<Vec<String>> {
    if pairs.is_empty() {
        if valid_solution(&state) {
            Some(solution)
        } else {
            None
        }
    } else {
        let pair = pairs[0];
        let rest_pairs = &pairs[1..];
        let ((r1, c1), (r2, c2)) = pair;
        
        for &(v1, v2) in &[('+', '-'), ('-', '+'), ('X', 'X')] {
            let mut new_solution = solution.clone();
            let mut new_state = state.clone();
            
            if v1 != 'X' {
                put_value(&mut new_solution, r1, c1, v1);
                put_value(&mut new_solution, r2, c2, v2);
                update_constraint_state(&mut new_state, r1, c1, v1, r2, c2, v2);
            }
            
            if valid_partial(&new_solution, &new_state, r1, c1, v1, r2, c2, v2) {
                if let Some(final_solution) = solve_with_pairs(_board, new_solution, rest_pairs, new_state) {
                    return Some(final_solution);
                }
            }
        }
        
        None
    }
}

fn put_value(solution: &mut Vec<String>, row: usize, col: usize, value: char) {
    let mut chars: Vec<char> = solution[row].chars().collect();
    chars[col] = value;
    solution[row] = chars.into_iter().collect();
}

fn update_constraint_state(
    state: &mut ConstraintState,
    r1: usize, c1: usize, v1: char,
    r2: usize, c2: usize, v2: char
) {
    update_for_position(state, r1, c1, v1);
    update_for_position(state, r2, c2, v2);
}

fn update_for_position(state: &mut ConstraintState, r: usize, c: usize, v: char) {
    if v == 'X' { return; }
    
    if v == '+' {
        state.plus_rows[r] += 1;
        state.plus_cols[c] += 1;
    } else if v == '-' {
        state.minus_rows[r] += 1;
        state.minus_cols[c] += 1;
    }
}

fn valid_partial(
    solution: &[String],
    state: &ConstraintState,
    r1: usize, c1: usize, v1: char,
    r2: usize, c2: usize, v2: char
) -> bool {
    if !constraints_not_violated(state) {
        return false;
    }
    
    if v1 == 'X' {
        true
    } else {
        check_adjacency(solution, r1, c1, v1) &&
        check_adjacency(solution, r2, c2, v2)
    }
}

fn check_adjacency(solution: &[String], r: usize, c: usize, value: char) -> bool {
    let rows = solution.len();
    let cols = solution[0].len();
    
    (r == 0 || solution[r-1].chars().nth(c).unwrap() != value) &&
    (r == rows-1 || solution[r+1].chars().nth(c).unwrap() != value) &&
    (c == 0 || solution[r].chars().nth(c-1).unwrap() != value) &&
    (c == cols-1 || solution[r].chars().nth(c+1).unwrap() != value)
}

fn constraints_not_violated(state: &ConstraintState) -> bool {
    not_exceeding_constraints(&state.plus_rows, &state.left_constraints) &&
    not_exceeding_constraints(&state.minus_rows, &state.right_constraints) &&
    not_exceeding_constraints(&state.plus_cols, &state.top_constraints) &&
    not_exceeding_constraints(&state.minus_cols, &state.bottom_constraints)
}

fn not_exceeding_constraints(counts: &[i32], constraints: &[i32]) -> bool {
    (0..constraints.len()).all(|i| {
        let constraint = constraints[i];
        let count = counts[i];
        constraint == -1 || count <= constraint
    })
}

fn valid_solution(state: &ConstraintState) -> bool {
    check_constraints(&state.plus_rows, &state.left_constraints) &&
    check_constraints(&state.minus_rows, &state.right_constraints) &&
    check_constraints(&state.plus_cols, &state.top_constraints) &&
    check_constraints(&state.minus_cols, &state.bottom_constraints)
}

fn check_constraints(counts: &[i32], constraints: &[i32]) -> bool {
    (0..constraints.len()).all(|i| {
        let constraint = constraints[i];
        let count = counts[i];
        constraint == -1 || count == constraint
    })
}

#[cfg(test)]
#[path = "tests.rs"]
mod tests;