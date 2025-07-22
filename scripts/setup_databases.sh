#!/bin/bash
set -e  # Exit if any command fails

# Define directories
DB_DIR="$PWD/databases"
mkdir -p "$DB_DIR"

checkm_db_dir="$DB_DIR/checkm"

# Some key files that must be present
required_files=(
    "$checkm_db_dir/selected_marker_sets.tsv"
    "$checkm_db_dir/pfam"
    "$checkm_db_dir/hmms"
    "$checkm_db_dir/taxon_marker_sets.tsv"
)

# Check whether all of them exist
all_exist=true
for item in "${required_files[@]}"; do
    if [ ! -e "$item" ]; then
        all_exist=false
        break
    fi
done

if [ "$all_exist" = false ]; then
    echo "CheckM DB not found or incomplete. Proceeding with download..."
    rm -rf "$checkm_db_dir"

echo "[1/2] Downloading CheckM database..."
    mkdir -p "$checkm_db_dir"
    cd "$DB_DIR/checkm"
    wget https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz
    tar -xvzf checkm_data_2015_01_16.tar.gz
    cd -

    mkdir -p "$PWD/flags"
    touch "$PWD/flags/checkm.done"

else
    echo "CheckM database already exists."
fi

echo "[2/2] Downloading Bakta database..."

bakta_db_dir="$DB_DIR/bakta_db"

# Some key files that must be present
required_files=(
    "$bakta_db_dir/db/bakta.db"
    "$bakta_db_dir/db/antifam.h3f"
    "$bakta_db_dir/db/pfam.h3i"
    "$bakta_db_dir/db/version.json"
)

# Check whether all of them exist
all_files_exist=true
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        all_files_exist=false
        break
    fi
done

if [ "$all_files_exist" = false ]; then
    echo "Bakta DB not found or incomplete. Proceeding with download..."
    rm -rf "$bakta_db_dir"

    if ! conda env list | awk '{print $1}' | grep -q "^bakta$"; then
        echo "📦  Creating Conda env ‘bakta’ from envs/bakta.yaml…"
        conda env create -f envs/bakta.yaml -n bakta
    else
        echo "✅  Conda env ‘bakta’ already exists. Skipping creation."
    fi

    echo "⬇️  Downloading Bakta database..."
    conda run -n bakta bakta_db download --output "$bakta_db_dir" --type full

    mkdir -p "$PWD/flags"
    touch "$PWD/flags/bakta.done"
else
    echo "✅ Bakta DB already exists and is complete."
fi
