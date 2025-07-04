from setuptools import setup, find_packages

setup(
    name="dadir-defender",
    version="1.0.0",
    author="Dadir",
    description="Windows security monitoring agent with GUI dashboard",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    packages=find_packages(),
    install_requires=[
        "psutil>=5.9.0",
        "Pillow>=9.0.0",
        "pystray>=0.19.0",
    ],
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Intended Audience :: System Administrators",
        "License :: OSI Approved :: MIT License",
        "Operating System :: Microsoft :: Windows",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Topic :: System :: Monitoring",
        "Topic :: Security",
    ],
    python_requires=">=3.8",
    entry_points={
        "console_scripts": [
            "dadir-defender=UI.dashboard:main",
        ],
    },
)