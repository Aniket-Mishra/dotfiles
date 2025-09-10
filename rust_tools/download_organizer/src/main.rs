use chrono::{DateTime, Local};
use std::fs;
use std::io;
use std::path::Path;

fn main() -> io::Result<()> {
    let downloads = dirs::download_dir().expect("Could not find Downloads directory");

    let rules = vec![
        (
            vec![
                "jpg", "png", "webp", "gif", "jpeg", "heic", "heif", "bmp", "tiff", "avif", "raw",
                "svg", "eps", "ai",
            ],
            "images",
        ),
        (vec!["docx", "txt", "doc", "md", "tex"], "documents"),
        (
            vec![
                "xlsx", "xls", "csv", "tsv", "parquet", "json", "feather", "sql",
            ],
            "data_files",
        ),
        (vec!["pdf"], "pdfs"),
        (
            vec!["sh", "rs", "c", "cpp", "py", "js", "html", "css"],
            "scripts",
        ),
        (vec!["dmg", "pkg", "app"], "apps"),
        (
            vec![
                "tar.gz", "bz2", "rar", "gz", "tar", "tbz2", "tgz", "zip", "Z", "7z",
            ],
            "compressed",
        ),
    ];

    // not recursive
    for entry in fs::read_dir(&downloads)? {
        let entry = entry?;
        let path = entry.path();
        if !path.is_file() {
            continue;
        }
        let mut moved = false;
        if let Some(ext) = path
            .extension()
            .and_then(|e| e.to_str())
            .map(|e| e.to_lowercase())
        {
            for (extensions, folder) in &rules {
                if extensions.contains(&ext.as_str()) {
                    move_and_rename_file(&path, &downloads, folder)?;
                    moved = true;
                    break;
                }
            }
        }
        // misc for all else. Folders are untouched cuz I make folders in downloads.
        if !moved {
            move_and_rename_file(&path, &downloads, "misc")?;
        }
    }

    Ok(())
}

fn move_and_rename_file(path: &Path, downloads: &Path, folder: &str) -> io::Result<()> {
    let dest_dir = downloads.join(folder);
    fs::create_dir_all(&dest_dir)?;

    let metadata = fs::metadata(&path)?;
    let created = metadata
        .created()
        .or_else(|_| metadata.modified()) // Fallback
        .unwrap_or_else(|_| std::time::SystemTime::now());
    let datetime: DateTime<Local> = created.into();
    let filename = path.file_stem().unwrap().to_string_lossy();
    let ext = path.extension().and_then(|e| e.to_str()).unwrap_or("");
    let new_name = format!(
        "{}_{}.{}",
        filename,
        datetime.format("%Y-%m-%d_%H-%M-%S"),
        ext
    );
    let new_path = dest_dir.join(&new_name);

    // Print what file is moved, where, and its new name
    println!(
        "Moving file {} to folder '{}' as {}",
        path.display(),
        folder,
        new_name
    );

    fs::rename(&path, &new_path)?;
    Ok(())
}
