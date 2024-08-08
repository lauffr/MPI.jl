function Psend_init(buf::Buffer, comm::Comm, req::AbstractRequest=Request(); parts::Integer=1, dest::Integer, tag::Integer=0, infokws...)
	count, should_be_zero = divrem(buf.count, parts)
    if !iszero(should_be_zero)
        error("tried creating a partitioned send request handle with buffer size $(buf.count) shared evenly between $(parts) partitions, but $(buf.count) is not a multiple of $(parts)")
    end
	@assert isnull(req)
    API.MPI_Psend_init(buf.data, parts, count, buf.datatype, dest, tag, comm, Info(infokws), req)
	setbuffer!(req, buf)
	return req
end

function Precv_init(buf::Buffer, comm::Comm, req::AbstractRequest=Request(); parts::Integer=1, source::Integer=API.MPI_ANY_SOURCE[], tag::Integer=API.MPI_ANY_TAG[], infokws...)
	count, should_be_zero = divrem(buf.count, parts)
    if !iszero(should_be_zero)
        error("tried creating a partitioned receive request handle with buffer size $(buf.count) shared evenly between $(parts) partitions, but $(buf.count) is not a multiple of $(parts)")
    end
	@assert isnull(req)
    API.MPI_Precv_init(buf.data, parts, count, buf.datatype, source, tag, comm, Info(infokws), req)
	setbuffer!(req, buf)
	return req
end

function Pready(req::AbstractRequest; part::Integer)
	API.MPI_Pready(part, req)
	return nothing
end

function Parrived(req::AbstractRequest; part::Integer)
	flag = Ref{Cint}()
	API.MPI_Parrived(req, part, flag)
	return flag[] != 0
end
