#!/bin/bash
set -e  # Exit if any command fails

# Define directories
TOOLS_DIR="$PWD/tools"

mkdir -p "$TOOLS_DIR"

echo "[1/5] Cloning POCP..."
if [ ! -d "$TOOLS_DIR/pocp" ]; then
    git clone https://github.com/hoelzer/pocp.git "$TOOLS_DIR/pocp"
else
    echo "POCP already cloned."
fi

echo "[2/5] Cloning CRISPRcasIdentifier..."
if [ ! -d "$TOOLS_DIR/crispr" ]; then
    mkdir -p "$TOOLS_DIR/crispr"
    cd "$TOOLS_DIR/crispr"
    wget https://github.com/BackofenLab/CRISPRcasIdentifier/archive/v1.1.0.tar.gz
    tar -xzf v1.1.0.tar.gz
    # Include gdown + model files here
    cd -
else
    echo "CRISPRcasIdentifier already set up."
fi

echo "[3/5] Cloning RGI and installing..."
if [ ! -d "$TOOLS_DIR/rgi" ]; then
    git clone https://github.com/arpcard/rgi.git "$TOOLS_DIR/rgi"
    cd "$TOOLS_DIR/rgi"
    pip3 install .
    rgi auto_load
    # Optional: download CARD JSON manually if needed
    cd -
fi

echo "[4/5] Setting up Minimap2..."

if [ ! -d "$TOOLS_DIR/minimap2" ]; then
    mkdir -p "$TOOLS_DIR/minimap2"
    cd "$TOOLS_DIR/minimap2"
    
    echo "Downloading Minimap2 v2.28..."
    curl -LO https://github.com/lh3/minimap2/releases/download/v2.28/minimap2-2.28_x64-linux.tar.bz2
    
    echo "Extracting Minimap2..."
    tar -xvjf minimap2-2.28_x64-linux.tar.bz2
    
    echo "Moving binary to tools directory..."
    mv minimap2-2.28_x64-linux/minimap2 .
    
    echo "Cleaning up..."
    rm -rf minimap2-2.28_x64-linux*
    
    echo "Minimap2 setup complete."
else
    echo "Minimap2 is already installed."
fi

echo "[5/5] Setting up Phigaro..."

echo "✅ All tools are set up."