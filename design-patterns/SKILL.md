---
name: design-patterns
description: >
  Scans code to detect problems, proposes the best design pattern with tradeoffs, and implements it on confirmation.
  Trigger: When explicitly asked to improve architecture, suggest a design pattern, or analyze code structure. Do NOT self-activate during sdd-apply or sdd-verify.
license: Apache-2.0
metadata:
  author: atarico
  version: "1.0"
---

## When to Use

Use this skill when:
- Code has a smell but the right solution isn't obvious
- Asked to improve code architecture or structure
- Detecting duplication, coupling, or testability problems
- Explicitly asked to apply or suggest a design pattern

---

## Protocol

Three phases. Never skip to Implement without completing Scout and Architect first.

### Phase 1 — Scout

Read the codebase and collect raw observations. Do NOT propose solutions yet.

Detect:
1. **Language** — TypeScript, Python, Java, or other (determines idiomatic implementation)
2. **Framework context** — NestJS, Spring, Django, etc. (changes which patterns are already built-in)
3. **Code smells** — see the Detection Signals table below
4. **Existing patterns** — what's already in use (avoid proposing what's already there)

Return: a flat list of observed smells with file locations.

### Phase 2 — Architect

Map each smell to candidate patterns. For each candidate, evaluate:

```
PROBLEM: <what's wrong and where>
PATTERN: <name>
WHY: <why this pattern solves the specific problem>
TRADEOFF: <what it adds in complexity, indirection, or boilerplate>
ALTERNATIVE: <other pattern that could work, and when to prefer it>
OVERKILL?: <yes/no — if yes, explain why simpler is better here>
```

If the code is small, simple, or the pattern adds more complexity than it resolves → mark as **OVERKILL** and recommend doing nothing or a simpler refactor.

Present the full proposal and **wait for user confirmation before implementing**.

### Phase 3 — Implementer

Only runs after explicit user confirmation of a specific pattern.

Produce a refactored implementation:
- Idiomatic for the detected language (see Language Guide below)
- Minimal diff — change only what the pattern requires
- Include a before/after comparison for the key files

---

## Detection Signals

| Pattern | Code Smell / Signal |
|---------|---------------------|
| **Singleton** | Global state, config objects, "only one should exist", shared mutable state |
| **Factory Method** | `new` calls scattered across the codebase, object creation conditioned by type/string |
| **Abstract Factory** | Families of related objects that need to change together, platform-specific creation |
| **Builder** | Constructors with 4+ optional parameters, telescoping constructors, complex object assembly |
| **Adapter** | Two incompatible interfaces that need to work together, third-party library wrapping |
| **Decorator** | Need to add behavior dynamically without modifying the original class or subclassing |
| **Facade** | Complex subsystem used directly from many places, needs a simplified entry point |
| **Proxy** | Need to control access, add caching, lazy initialization, or transparent logging |
| **Observer** | "Notify when X changes", manual listener lists, tight coupling between state and reactions |
| **Strategy** | `if/else` or `switch` on behavior type, algorithm swapped at runtime |
| **Command** | Need undo/redo, operation queuing, logging of actions as objects |
| **Iterator** | Custom collection with no standard traversal, need to hide internal structure |
| **Template Method** | Algorithm skeleton with steps that vary by subclass, duplicated structure in subclasses |
| **Repository** | Data access calls (DB, API) mixed directly into business logic or service classes |
| **Dependency Injection** | Hard-coded dependencies via `new` inside classes, impossible to unit test in isolation |
| **Pub/Sub** | Modules that need to communicate without knowing each other, cross-cutting event handling |
| **MVC** | UI rendering logic mixed with business rules, presentation layer reads from DB directly |

---

## Language Guide

### TypeScript

| Pattern | Idiomatic approach |
|---------|-------------------|
| Singleton | Module-level export: `export const instance = new X()` — no `getInstance()` needed |
| Decorator | Use native `@Decorator` syntax if available (NestJS, Angular). Otherwise manual wrapper. |
| Dependency Injection | NestJS `@Injectable()` if in NestJS context; InversifyJS or tsyringe for standalone |
| Strategy | Interface + multiple implementations; or function type `(input: T) => R` for simple cases |
| Observer | `EventEmitter` for Node; RxJS `Subject` for reactive streams |
| Factory Method | Static factory method or standalone factory function, leveraging union types |
| Repository | Interface + class implementing it; mock the interface in tests |

### Python

| Pattern | Idiomatic approach |
|---------|-------------------|
| Singleton | Module-level instance — NOT `__instance` class var. Just `instance = MyClass()` at module level. |
| Decorator | **Distinguish** GoF Decorator (wrapper class) from Python `@decorator` (function wrapper). Propose the right one. |
| Builder | `@dataclass` with `field(default=...)` for optional params; or fluent builder for complex cases |
| Abstract Factory | `ABC` + `@abstractmethod`. Use `Protocol` for structural subtyping (Python 3.8+). |
| Strategy | Callable / `Protocol` with `__call__`; or ABC with abstract method |
| Repository | ABC interface + concrete class; inject via constructor for testability |
| Dependency Injection | Constructor injection; use `dependency_injector` library only if complexity warrants it |
| Observer | `list` of callables, or `pyee` EventEmitter for event-driven code |

### Java

| Pattern | Idiomatic approach |
|---------|-------------------|
| Singleton | Enum singleton (thread-safe, serialization-safe) or static inner class holder |
| Builder | Lombok `@Builder` if available; otherwise static nested Builder class |
| Factory Method | Static factory method; or `FactoryBean` in Spring context |
| Dependency Injection | Spring `@Autowired` / `@Component` if in Spring; manual constructor injection otherwise |
| Strategy | Interface + implementations; Java 8+ → lambda if strategy is a single method |
| Command | Functional interface (`Runnable`, `Callable`, or custom) for simple cases; class hierarchy for undo/redo |
| Observer | `java.util.Observer` (legacy) or custom listener interface; Spring `ApplicationEvent` in Spring |
| Repository | Spring Data `JpaRepository` if in Spring; otherwise interface + implementation |
| Decorator | Interface + wrapper class; avoid deep inheritance chains |

---

## Rules

- Only activate when explicitly requested — never self-trigger during sdd-apply or sdd-verify
- Scout and Architect are always required — never skip to Implement
- Detect the language first — wrong-language examples are worse than no examples
- Always include TRADEOFF and ALTERNATIVE in every proposal
- OVERKILL is a valid and important output — say it when the pattern doesn't justify itself
- Never propose a pattern that's already correctly implemented in the codebase
- Implementer runs ONLY after explicit user confirmation of a specific proposal
- Minimal diff — only change what the pattern requires, nothing else
- In Python: always clarify whether the proposal is GoF Decorator or Python decorator syntax
- In TypeScript: prefer module-level Singleton over the classic class-with-getInstance approach
- In Java: prefer Lombok @Builder over manual Builder when the dependency is already present
