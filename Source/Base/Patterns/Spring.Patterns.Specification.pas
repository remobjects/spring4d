{***************************************************************************}
{                                                                           }
{           Spring Framework for Delphi                                     }
{                                                                           }
{           Copyright (c) 2009-2024 Spring4D Team                           }
{                                                                           }
{           http://www.spring4d.org                                         }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}

{$I Spring.inc}

unit Spring.Patterns.Specification;

interface

uses
  Spring;

type

  /// <summary>
  ///   Defines the core methods of a specification interface.
  /// </summary>
  /// <remarks>
  ///   This interface is designed to be binary compatible with
  ///   Spring.Predicate&lt;T&gt;.
  /// </remarks>
  ISpecification<T> = interface(IInvokable) //FI:W524
    ['{95E8259B-1397-4A66-9E12-A734E97C1C7C}']
    function IsSatisfiedBy(const item: T): Boolean;
    // DO NOT ADD ANY METHODS HERE!!!
  end;

  /// <summary>
  ///   Provides the easy-going specification holder with operator overloads.
  /// </summary>
  Specification<T> = record
  private
    fInstance: ISpecification<T>;
  public
    function IsSatisfiedBy(const item: T): Boolean; inline;

    class operator Implicit(const specification: ISpecification<T>): Specification<T>;
    class operator Implicit(const specification: Predicate<T>): Specification<T>;
    class operator Implicit(const specification: Specification<T>): ISpecification<T>;
    class operator Implicit(const specification: Specification<T>): Predicate<T>;
    class operator Explicit(const specification: ISpecification<T>): Specification<T>;
    class operator Explicit(const specification: Predicate<T>): Specification<T>;
    class operator Explicit(const specification: Specification<T>): ISpecification<T>;

    class operator LogicalAnd(const left, right: Specification<T>): Specification<T>;
    class operator LogicalOr(const left, right: Specification<T>): Specification<T>;
    class operator LogicalNot(const value: Specification<T>): Specification<T>;

    class operator In(const left: T; const right: Specification<T>): Boolean; inline;
  end;

  /// <summary>
  ///   Provides the abstract base class for ISpecification<T>.
  /// </summary>
  TSpecification<T> = class abstract(TInterfacedObject, ISpecification<T>
{$IFNDEF ELEMENTS}
    , Predicate<T>
{$ENDIF}
  )
  protected
{$IFNDEF ELEMENTS}
    function Predicate<T>.Invoke = IsSatisfiedBy;
{$ENDIF}
    function IsSatisfiedBy(const item: T): Boolean; virtual; abstract;
  end;

{$IFDEF ELEMENTS}
  // Delphi treats anonymous-method types as Invoke-based interface objects.
  // Elements models "reference to" types as delegates instead, so adapt them
  // through a small wrapper rather than inheriting from Predicate<T>.
  TPredicateSpecification<T> = class sealed(TSpecification<T>)
  private
    fPredicate: Predicate<T>;
  public
    constructor Create(const predicate: Predicate<T>);
  protected
    function IsSatisfiedBy(const item: T): Boolean; override;
  end;
{$ENDIF}

  TUnarySpecification<T> = class abstract(TSpecification<T>)
  protected
    fValue: ISpecification<T>;
  public
    constructor Create(const value: ISpecification<T>);
  end;

  TBinarySpecification<T> = class abstract(TSpecification<T>)
  protected
    fLeft: ISpecification<T>;
    fRight: ISpecification<T>;
  public
    constructor Create(const left, right: ISpecification<T>);
  end;

  TLogicalNotSpecification<T> = class sealed(TUnarySpecification<T>)
  protected
    function IsSatisfiedBy(const item: T): Boolean; override;
  end;

  TLogicalAndSpecification<T> = class sealed(TBinarySpecification<T>)
  protected
    function IsSatisfiedBy(const item: T): Boolean; override;
  end;

  TLogicalOrSpecification<T> = class sealed(TBinarySpecification<T>)
  protected
    function IsSatisfiedBy(const item: T): Boolean; override;
  end;

implementation


{$REGION 'Specification<T>'}

function Specification<T>.IsSatisfiedBy(const item: T): Boolean;
begin
  Result := Assigned(fInstance) and fInstance.IsSatisfiedBy(item);
end;

class operator Specification<T>.Implicit(
  const specification: ISpecification<T>): Specification<T>;
begin
  Result.fInstance := specification;
end;

class operator Specification<T>.Implicit(
  const specification: Predicate<T>): Specification<T>;
begin
{$IFDEF ELEMENTS}
  Result.fInstance := TPredicateSpecification<T>.Create(specification);
{$ELSE}
  Predicate<T>(Result.fInstance) := specification;
{$ENDIF}
end;

class operator Specification<T>.Implicit(
  const specification: Specification<T>): ISpecification<T>;
begin
  Result := specification.fInstance;
end;

class operator Specification<T>.Implicit(
  const specification: Specification<T>): Predicate<T>;
begin
{$IFDEF ELEMENTS}
  var instance := specification.fInstance;
  if Assigned(instance) then
    Result :=
      function(const item: T): Boolean
      begin
        Result := instance.IsSatisfiedBy(item);
      end
  else
    Result := nil;
{$ELSE}
  ISpecification<T>(Result) := specification.fInstance;
{$ENDIF}
end;

class operator Specification<T>.In(const left: T;
  const right: Specification<T>): Boolean;
begin
  Result := right.IsSatisfiedBy(left);
end;

class operator Specification<T>.Explicit(
  const specification: ISpecification<T>): Specification<T>;
begin
  Result.fInstance := specification;
end;

class operator Specification<T>.Explicit(
  const specification: Predicate<T>): Specification<T>;
begin
{$IFDEF ELEMENTS}
  Result.fInstance := TPredicateSpecification<T>.Create(specification);
{$ELSE}
  Predicate<T>(Result.fInstance) := specification;
{$ENDIF}
end;

class operator Specification<T>.Explicit(
  const specification: Specification<T>): ISpecification<T>;
begin
  Result := specification.fInstance;
end;

class operator Specification<T>.LogicalAnd(const left,
  right: Specification<T>): Specification<T>;
begin
  Result.fInstance := TLogicalAndSpecification<T>.Create(
    left.fInstance, right.fInstance)
end;

class operator Specification<T>.LogicalOr(const left,
  right: Specification<T>): Specification<T>;
begin
  Result.fInstance := TLogicalOrSpecification<T>.Create(
    left.fInstance, right.fInstance);
end;

class operator Specification<T>.LogicalNot(
  const value: Specification<T>): Specification<T>;
begin
  Result.fInstance := TLogicalNotSpecification<T>.Create(
    value.fInstance);
end;

{$ENDREGION}


{$IFDEF ELEMENTS}
{$REGION 'TPredicateSpecification<T>'}

constructor TPredicateSpecification<T>.Create(const predicate: Predicate<T>);
begin
  fPredicate := predicate;
end;

function TPredicateSpecification<T>.IsSatisfiedBy(const item: T): Boolean;
begin
  Result := Assigned(fPredicate) and fPredicate(item);
end;

{$ENDREGION}
{$ENDIF}


{$REGION 'TUnarySpecification<T>'}

constructor TUnarySpecification<T>.Create(const value: ISpecification<T>);
begin
  fValue := value;
end;

{$ENDREGION}


{$REGION 'TBinarySpecification<T>'}

constructor TBinarySpecification<T>.Create(const left, right: ISpecification<T>);
begin
  fLeft := left;
  fRight := right;
end;

{$ENDREGION}


{$REGION 'TLogicalNotSpecification<T>'}

function TLogicalNotSpecification<T>.IsSatisfiedBy(const item: T): Boolean;
begin
  Result := not fValue.IsSatisfiedBy(item);
end;

{$ENDREGION}


{$REGION 'TLogicalAndSpecification<T>'}

function TLogicalAndSpecification<T>.IsSatisfiedBy(const item: T): Boolean;
begin
  Result := fLeft.IsSatisfiedBy(item) and fRight.IsSatisfiedBy(item);
end;

{$ENDREGION}


{$REGION 'TLogicalOrSpecification<T>'}

function TLogicalOrSpecification<T>.IsSatisfiedBy(const item: T): Boolean;
begin
  Result := fLeft.IsSatisfiedBy(item) or fRight.IsSatisfiedBy(item);
end;

{$ENDREGION}


end.
