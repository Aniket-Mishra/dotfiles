use anyhow::{bail, Context, Result};
use reqwest::blocking::Client;
use reqwest::header::{ACCEPT, AUTHORIZATION, USER_AGENT};
use serde_json::Value;
use std::{env, fs, path::Path};

fn main() -> Result<()> {
    let repo = env::var("REPO").unwrap_or_else(|_| "Aniket-Mishra/dotfiles".to_string());
    let readme_path = env::var("README_PATH").unwrap_or_else(|_| "README.md".to_string());
    let start_marker = "<!-- LANG_TABLE_START -->";
    let end_marker = "<!-- LANG_TABLE_END -->";
    let token = env::var("GITHUB_TOKEN").ok(); // optional, but raises rate limits
    let client = Client::builder().build()?;
    let url = format!("https://api.github.com/repos/{}/languages", repo);
    let mut req = client
        .get(&url)
        .header(ACCEPT, "application/vnd.github.v3+json")
        .header(USER_AGENT, "update-langs-script");

    if let Some(t) = &token {
        req = req.header(AUTHORIZATION, format!("Bearer {}", t));
    }

    let json: Value = req.send()?.error_for_status()?.json()?;
    let obj = json
        .as_object()
        .context("Unexpected response: expected object of {language: bytes}")?;

    if obj.is_empty() {
        bail!("No language data returned for repo {}", repo);
    }

    let total: f64 = obj.values().filter_map(|v| v.as_f64()).sum();
    let mut items: Vec<(String, f64)> = obj
        .iter()
        .filter_map(|(k, v)| v.as_f64().map(|n| (k.clone(), n)))
        .collect();

    items.sort_by(|a, b| b.1.partial_cmp(&a.1).unwrap());

    let mut table = String::from("| Language | % |\n|----------|---|\n");
    for (lang, bytes) in items {
        let perc = if total > 0.0 {
            (bytes / total) * 100.0
        } else {
            0.0
        };
        table.push_str(&format!("| {} | {:.2}% |\n", lang, perc));
    }

    let readme_contents = fs::read_to_string(&readme_path)
        .with_context(|| format!("Failed to read {}", readme_path))?;

    let (start_idx, end_idx) = match (
        readme_contents.find(start_marker),
        readme_contents.find(end_marker),
    ) {
        (Some(s), Some(e)) if e > s => (s, e),
        _ => {
            // Markers missing: append a new section to the bottom
            let appended = format!(
                "{}\n\n## Languages\n\n{}\n{}\n{}\n",
                readme_contents, start_marker, table, end_marker
            );
            fs::write(&readme_path, appended)
                .with_context(|| format!("Failed to write {}", readme_path))?;
            println!("✅ Added languages section to {}", readme_path);
            return Ok(());
        }
    };

    let before = &readme_contents[..start_idx + start_marker.len()];
    let after = &readme_contents[end_idx..];
    let new_contents = format!("{}\n{}\n{}", before, table, after);

    if new_contents != readme_contents {
        if let Some(parent) = Path::new(&readme_path).parent() {
            if !parent.as_os_str().is_empty() {
                fs::create_dir_all(parent).ok();
            }
        }
        fs::write(&readme_path, new_contents)
            .with_context(|| format!("Failed to write {}", readme_path))?;
        println!("✅ Updated languages table in {}", readme_path);
    } else {
        println!("ℹ️ No changes to {}", readme_path);
    }

    Ok(())
}
