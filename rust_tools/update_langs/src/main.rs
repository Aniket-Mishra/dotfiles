use anyhow::{anyhow, bail, Context, Result};
use reqwest::blocking::Client;
use reqwest::header::{ACCEPT, AUTHORIZATION, USER_AGENT};
use std::{collections::HashMap, env, fs};

const START: &str = "<!-- LANG_TABLE_START -->";
const END: &str = "<!-- LANG_TABLE_END -->";

fn main() -> Result<()> {
    let repo = env::var("REPO").unwrap_or_else(|_| "Aniket-Mishra/dotfiles".to_string());
    let readme_path = env::var("README_PATH").unwrap_or_else(|_| "README.md".to_string());
    let token = env::var("GITHUB_TOKEN").ok();

    let url = format!("https://api.github.com/repos/{repo}/languages");
    let client = Client::new();
    let mut req = client
        .get(&url)
        .header(ACCEPT, "application/vnd.github.v3+json")
        .header(USER_AGENT, "update-langs-script");

    if let Some(t) = &token {
        req = req.header(AUTHORIZATION, format!("Bearer {t}"));
    }

    let resp = req
        .send()
        .with_context(|| format!("request failed: {url}"))?;
    let status = resp.status();

    if !status.is_success() {
        let body = resp.text().unwrap_or_default();
        return Err(anyhow!("github api error {status}: {body}"));
    }

    let mut items: Vec<(String, u64)> = resp.json::<HashMap<String, u64>>()?.into_iter().collect();

    if items.is_empty() {
        bail!("no language data returned for repo {repo}");
    }

    items.sort_by(|a, b| b.1.cmp(&a.1));
    let total: f64 = items.iter().map(|(_, n)| *n as f64).sum();

    let header = "| Language | % |\n|----------|---|\n";
    let body = items
        .into_iter()
        .map(|(k, v)| {
            let p = if total > 0.0 {
                (v as f64 / total) * 100.0
            } else {
                0.0
            };
            format!("| {k} | {:.2}% |\n", p)
        })
        .collect::<String>();
    let table = format!("{header}{body}");

    let readme = fs::read_to_string(&readme_path)
        .with_context(|| format!("failed to read {readme_path}"))?;

    let (s, e) = match (readme.find(START), readme.find(END)) {
        (Some(s), Some(e)) if e > s => (s, e),
        (None, _) => {
            let updated = format!("{readme}\n\n## Languages\n\n{START}\n{table}\n{END}\n");
            fs::write(&readme_path, updated)
                .with_context(|| format!("failed to write {readme_path}"))?;
            println!("added languages section to {readme_path}");
            return Ok(());
        }
        (Some(_), None) => bail!("found start marker but not end marker"),
        (Some(s), Some(e)) if e <= s => bail!("end marker appears before start marker"),
        _ => unreachable!(),
    };

    let before = &readme[..s + START.len()];
    let after = &readme[e..];
    let new = format!("{before}\n{table}\n{after}");

    if new != readme {
        fs::write(&readme_path, new).with_context(|| format!("failed to write {readme_path}"))?;
        println!("updated languages table in {readme_path}");
    } else {
        println!("no changes to {readme_path}");
    }

    Ok(())
}
