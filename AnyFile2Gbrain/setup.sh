#!/bin/bash
# Setup script for AnyFile2Gbrain skill
# Installs dependencies for converting various file formats to Markdown

set -e

echo "=== AnyFile2Gbrain Setup ==="

# Check for pandoc (best for Word/PDF conversion)
if ! command -v pandoc &> /dev/null; then
    echo "Installing pandoc via Homebrew..."
    brew install pandoc
else
    echo "pandoc already installed: $(pandoc --version | head -1)"
fi

# Install Python libraries for file conversion
echo "Installing Python libraries..."
pip3 install --quiet --break-system-packages openpyxl pandas python-pptx python-docx pdfplumber tabulate

# Verify installations
echo ""
echo "=== Verification ==="
echo "pandoc: $(pandoc --version 2>/dev/null | head -1 || echo 'NOT INSTALLED')"
python3 -c "import openpyxl; print('openpyxl:', openpyxl.__version__)" 2>/dev/null || echo "openpyxl: NOT INSTALLED"
python3 -c "import pandas; print('pandas:', pandas.__version__)" 2>/dev/null || echo "pandas: NOT INSTALLED"
python3 -c "import pptx; print('python-pptx:', pptx.__version__)" 2>/dev/null || echo "python-pptx: NOT INSTALLED"
python3 -c "import docx; print('python-docx:', docx.__version__)" 2>/dev/null || echo "python-docx: NOT INSTALLED"
python3 -c "import pdfplumber; print('pdfplumber:', pdfplumber.__version__)" 2>/dev/null || echo "pdfplumber: NOT INSTALLED"

echo ""
echo "=== Setup Complete ==="
echo "You can now use /AnyFile2Gbrain to import files into your Gbrain knowledge base."