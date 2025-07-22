#!/bin/bash
set -e

echo "🔧 Starting full pipeline setup..."

bash scripts/setup_tools.sh
bash scripts/setup_databases.sh
bash scripts/modified_packages.sh

conda env remove -n bakta


echo "✅ All setup complete!"
