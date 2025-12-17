from setuptools import setup, find_packages

setup(
    name="hyperkitlabs-erc1066-x402",
    version="0.1.0",
    description="Python SDK for ERC-1066-x402 gateway",
    author="HyperKit Labs",
    author_email="hyperkitdev@gmail.com",
    packages=find_packages(),
    install_requires=[
        "requests>=2.31.0",
        "pydantic>=2.5.0",
        "web3>=6.11.0",
    ],
    python_requires=">=3.8",
)

