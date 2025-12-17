# Contributing to ERC-1066-x402

Thank you for your interest in contributing to ERC-1066-x402!

## Code Style Guide

### Solidity

- Follow the [Solidity Style Guide](https://docs.soliditylang.org/en/latest/style-guide.html)
- Use 4 spaces for indentation
- Maximum line length: 120 characters
- Use descriptive names for variables, functions, and contracts
- Add NatSpec comments for all public functions

### TypeScript/JavaScript

- Follow [TypeScript style guide](https://google.github.io/styleguide/tsguide.html)
- Use 2 spaces for indentation
- Maximum line length: 100 characters
- Use ESLint and Prettier

## Testing Requirements

- All new code must include tests
- Test coverage must be 90%+ for contracts
- Test coverage must be 80%+ for gateway/SDKs
- All tests must pass before submitting PR

## Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass (`npm test`)
6. Update documentation if needed
7. Commit your changes (`git commit -m 'Add amazing feature'`)
8. Push to your branch (`git push origin feature/amazing-feature`)
9. Open a Pull Request

## Commit Message Format

We use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

Example: `feat: add new validator for ERC-20 tokens`

## Code Review

- All PRs require at least 2 approvals
- Code must pass CI checks
- Security-sensitive changes require additional review

## Security Reporting

Please report security vulnerabilities to hyperkitdev@gmail.com

Do not open public issues for security vulnerabilities.

## Questions?

Open an issue or contact the maintainers.

