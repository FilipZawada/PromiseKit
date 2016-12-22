import Foundation

open class UnfailablePromise<T> {

    @discardableResult
    public func then<U>(on q: DispatchQueue = .default, execute body: @escaping (T) -> Promise<U>) -> UnfailablePromise<U> {
        fatalError("abstract method")
    }

    public func then<U>(on q: DispatchQueue = .default, execute body: @escaping (T) throws -> Promise<U>) -> Promise<U> {
        fatalError("abstract method")
    }

    @discardableResult
    public func then<U>(on q: DispatchQueue = .default, execute body: @escaping (T) -> U) -> UnfailablePromise<U> {
        fatalError("abstract method")
    }

    public func then<U>(on q: DispatchQueue = .default, execute body: @escaping (T) throws -> U) -> Promise<U> {
        fatalError("abstract method")
    }

}