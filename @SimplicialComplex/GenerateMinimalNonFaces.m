% FROM THE SAGE REFERENCE FOR SimplicialComplex.minimal_nonfaces().
% SEE http://www.sagemath.org/doc/reference/sage/homology/simplicial_complex.html
% ALSO http://uw.sagenb.org/src/homology/simplicial_complex.py
%
% Algorithm: first take the complement (within the vertex set) of each
% facet, obtaining a set (f_1, f_2, ...) of simplices. Now form the set of
% all simplices of the form (v_1, v_2, ...) where vertex v_i is in face
% f_i. This set will contain the minimal nonfaces and may contain some
% non-minimal nonfaces also, so loop through the set to find the minimal
% ones. (The last two steps are taken care of by the _transpose_simplices
% routine.)
function GenerateMinimalNonFaces(this)
    A = ~this.Facets.ToMatrix();

    answer = [];

    if size(A, 1) == 1
        iNumSimplices = nnz(A);
        iNumVerts = size(A, 2);
        answer = zeros(iNumSimplices, iNumVerts);
        answer(sub2ind([iNumSimplices, iNumVerts], ...
                       1 : iNumSimplices, ...
                       find(A))) ...
            = 1;
    elseif size(A, 1) > 1
        face = A(1, :);
        rest = A(2 : end, :);

        new_simplices = zeros(0, size(A, 2));

        for v = find(face)

        end
    end
end

% THE SAGE CODE FOR THE ABOVE FUNCTION WHERE `simplices` is `A`.
% 
% answer = []
% if len(simplices) == 1:
%     answer = [Simplex((v,)) for v in simplices[0]]
% elif len(simplices) > 1:
%     face = simplices[0]
%     rest = simplices[1:]
%     new_simplices = []
%     for v in face:
%         for partial in self._transpose_simplices(*rest):
%             if v not in partial:
%                 L = [v] + list(partial)
%                 L.sort()
%                 simplex = Simplex(L)
%             else:
%                 simplex = partial
%             add_simplex = True
%             simplices_to_delete = []
%             for already in answer:
%                 if add_simplex:
%                     if already.is_face(simplex):
%                         add_simplex = False
%                     if add_simplex and simplex.is_face(already):
%                         simplices_to_delete.append(already)
%             if add_simplex:
%                 answer.append(simplex)
%             for x in simplices_to_delete:
%                 answer.remove(x)
% return answer